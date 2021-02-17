defmodule Cldr.Http do
  @moduledoc """
  Supports securely downloading https content.

  """

  @doc """
  Securely download https content from
  a URL.

  This function uses the built-in `:httpc`
  client but enables certificate verification
  which is not enabled by `:httc` by default.

  ### Arguments

  * `url` is a binary URL

  ### Returns

  * `{:ok, body}` if the return is successful

  * `{:error, error}` if the download is
     unsuccessful. An error will also be logged
     in these cases.

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

    url = String.to_charlist(url)

    case :httpc.request(:get, {url, headers()}, https_opts(), []) do
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
      Application.get_env(:ex_cldr, :cacertfile),

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

  defp certificate_store do
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

  defp https_opts do
    [ssl:
      [
        verify: :verify_peer,
        cacertfile: certificate_store(),
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ]
      ]
    ]
  end

end