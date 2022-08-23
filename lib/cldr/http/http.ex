defmodule Cldr.Http do
  @moduledoc """
  Supports securely downloading https content.

  """

  @cldr_unsafe_https "CLDR_UNSAFE_HTTPS"

  @doc """
  Securely download https content from
  a URL.

  This function uses the built-in `:httpc`
  client but enables certificate verification
  which is not enabled by `:httc` by default.

  See also https://erlef.github.io/security-wg/secure_coding_and_deployment_hardening/ssl

  ### Arguments

  * `url` is a binary URL

  ### Returns

  * `{:ok, body}` if the return is successful

  * `{:error, error}` if the download is
     unsuccessful. An error will also be logged
     in these cases.

  ### Unsafe HTTPS

  If the environment variable `CLDR_UNSAFE_HTTPS` is
  set to anything other than `FALSE`, `false`, `nil`
  or `NIL` then no peer verification of certificates
  is performed. Setting this variable is not recommended
  but may be required is where peer verification for
  unidentified reasons. Please [open an issue](https://github.com/elixir-cldr/cldr/issues)
  if this occurs.

  ### Certificate stores

  In order to keep dependencies to a minimum,
  `get/1` attempts to locate an already installed
  certificate store. It will try to locate a
  store in the following order which is intended
  to satisfy most host systems. The certificate
  store is expected to be a path name on the
  host system.

  ```elixir
  # A certificate store configured by the
  # developer
  Application.get_env(:ex_cldr, :cacertfile)

  # Populated if hex package `CAStore` is configured
  CAStore.file_path()

  # Populated if hex package `certfi` is configured
  :certifi.cacertfile()

  # Debian/Ubuntu/Gentoo etc.
  "/etc/ssl/certs/ca-certificates.crt",

  # Fedora/RHEL 6
  "/etc/pki/tls/certs/ca-bundle.crt",

  # OpenSUSE
  "/etc/ssl/ca-bundle.pem",

  # OpenELEC
  "/etc/pki/tls/cacert.pem",

  # CentOS/RHEL 7
  "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem",

  # Open SSL on MacOS
  "/usr/local/etc/openssl/cert.pem",

  # MacOS & Alpine Linux
  "/etc/ssl/cert.pem"
  ```

  """
  @spec get(String.t) :: {:ok, binary} | {:error, any}

  def get(url) when is_binary(url) do
    require Logger

    hostname = String.to_charlist(URI.parse(url).host)
    url = String.to_charlist(url)

    case :httpc.request(:get, {url, headers()}, https_opts(hostname), []) do
      {:ok, {{_version, 200, 'OK'}, _headers, body}} ->
        {:ok, body}

      {_, {{_version, code, message}, _headers, _body}} ->
        Logger.bare_log(
          :error,
          "Failed to download #{url}. " <>
            "HTTP Error: (#{code}) #{inspect(message)}"
        )

        {:error, code}

      {:error, {:failed_connect, [{_, {host, _port}}, {_, _, sys_message}]}} ->
        Logger.bare_log(
          :error,
          "Failed to connect to #{inspect(host)} to download #{inspect url}"
        )

        {:error, sys_message}

      {:error, {other}} ->
        Logger.bare_log(
          :error,
          "Failed to download #{inspect url}. Error #{inspect other}"
        )

        {:error, other}
    end
  end

  defp headers do
    # [{'Connection', 'close'}]
    []
  end

  @certificate_locations [
      # Configured cacertfile
      Application.compile_env(:ex_cldr, :cacertfile),

      # Populated if hex package CAStore is configured
      if(Code.ensure_loaded?(CAStore), do: CAStore.file_path()),

      # Populated if hex package certfi is configured
      if(Code.ensure_loaded?(:certifi), do: :certifi.cacertfile() |> List.to_string),

      # Debian/Ubuntu/Gentoo etc.
      "/etc/ssl/certs/ca-certificates.crt",

      # Fedora/RHEL 6
      "/etc/pki/tls/certs/ca-bundle.crt",

      # OpenSUSE
      "/etc/ssl/ca-bundle.pem",

      # OpenELEC
      "/etc/pki/tls/cacert.pem",

      # CentOS/RHEL 7
      "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem",

      # Open SSL on MacOS
      "/usr/local/etc/openssl/cert.pem",

      # MacOS & Alpine Linux
      "/etc/ssl/cert.pem"
  ]
  |> Enum.reject(&is_nil/1)

  @doc false
  def certificate_store do
    @certificate_locations
    |> Enum.find(&File.exists?/1)
    |> raise_if_no_cacertfile!
    |> :erlang.binary_to_list
  end

  defp raise_if_no_cacertfile!(nil) do
    raise RuntimeError, """
      No certificate trust store was found.
      Tried looking for: #{inspect @certificate_locations}

      A certificate trust store is required in
      order to download locales for your configuration.

      Since ex_cldr could not detect a system
      installed certificate trust store one of the
      following actions may be taken:

      1. Install the hex package `castore`. It will
         be automatically detected after recompilation.

      2. Install the hex package `certifi`. It will
         be automatically detected after recomilation.

      3. Specify the location of a certificate trust store
         by configuring it in `config.exs`:

         config :ex_cldr,
           cacertfile: "/path/to/cacertfile",
           ...

      """
  end

  defp raise_if_no_cacertfile!(file) do
    file
  end

  defp https_opts(hostname) do
    if secure_ssl?() do
      [ssl:
        [
          verify: :verify_peer,
          cacertfile: certificate_store(),
          depth: 4,
          ciphers: preferred_ciphers(),
          versions: protocol_versions(),
          eccs: preferred_eccs(),
          reuse_sessions: true,
          server_name_indication: hostname,
          secure_renegotiate: true,
          customize_hostname_check: [
            match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
          ]
        ]
      ]
    else
      [ssl:
        [
          verify: :verify_none,
          server_name_indication: hostname,
          secure_renegotiate: true,
          reuse_sessions: true,
          versions: protocol_versions(),
          ciphers: preferred_ciphers(),
          versions: protocol_versions(),
        ]
      ]
    end
  end

  def preferred_ciphers do
    preferred_ciphers =
      [
        # Cipher suites (TLS 1.3): TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        %{cipher: :aes_128_gcm, key_exchange: :any, mac: :aead, prf: :sha256},
        %{cipher: :aes_256_gcm, key_exchange: :any, mac: :aead, prf: :sha384},
        %{cipher: :chacha20_poly1305, key_exchange: :any, mac: :aead, prf: :sha256},
        # Cipher suites (TLS 1.2): ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:
        # ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:
        # ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        %{cipher: :aes_128_gcm, key_exchange: :ecdhe_ecdsa, mac: :aead, prf: :sha256},
        %{cipher: :aes_128_gcm, key_exchange: :ecdhe_rsa, mac: :aead, prf: :sha256},
        %{cipher: :aes_256_gcm, key_exchange: :ecdh_ecdsa, mac: :aead, prf: :sha384},
        %{cipher: :aes_256_gcm, key_exchange: :ecdh_rsa, mac: :aead, prf: :sha384},
        %{cipher: :chacha20_poly1305, key_exchange: :ecdhe_ecdsa, mac: :aead, prf: :sha256},
        %{cipher: :chacha20_poly1305, key_exchange: :ecdhe_rsa, mac: :aead, prf: :sha256},
        %{cipher: :aes_128_gcm, key_exchange: :dhe_rsa, mac: :aead, prf: :sha256},
        %{cipher: :aes_256_gcm, key_exchange: :dhe_rsa, mac: :aead, prf: :sha384}
      ]

    :ssl.filter_cipher_suites(preferred_ciphers, [])
  end

  def protocol_versions do
    if otp_version() < 25 do
      [:"tlsv1.2"]
    else
      [:"tlsv1.2", :"tlsv1.3"]
    end
  end

  def preferred_eccs do
    # TLS curves: X25519, prime256v1, secp384r1
    preferred_eccs = [:secp256r1, :secp384r1]
    :ssl.eccs() -- (:ssl.eccs() -- preferred_eccs)
  end

  def secure_ssl? do
    case System.get_env(@cldr_unsafe_https) do
      nil -> true
      "FALSE" -> false
      "false" -> false
      "nil" -> false
      "NIL" -> false
      _other -> true
    end
  end

  def otp_version do
    :erlang.system_info(:otp_release) |> List.to_integer
  end
end
