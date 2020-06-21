defmodule PickupWeb.AuthController do
  use PickupWeb, :controller
  plug Ueberauth

  alias Pickup.{Users, Guardian}

  alias Ueberauth.Strategy.Helpers

  # def login(conn, %{"provider" => provider, "origin" => origin}) do
  #   session = get_session(conn)
  #   current_user = Users.get!(session["current_user_id"])
  #
  #   require IEx
  #   IEx.pry()
  #
  #   data = %{
  #     client_id: System.get_env("DISCORD_APP_ID"),
  #     client_secret: System.get_env("DISCORD_APP_SECRET"),
  #     grant_type: "refresh_token",
  #     refresh_token: current_user.credentials,
  #     redirect_uri: "/#{provider}/callback",
  #     scope: "identify email connections guilds"
  #   }
  #
  #   {:ok, response} = HTTPoison.post("https://discord.com/api/v6/oauth2/token", data)
  #
  #   # conn
  #   # |> redirect(to: "/login/#{provider}")
  # end

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/login")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Users.find_or_create_ueberauth(auth) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Successfully authenticated.")
        |> configure_session(renew: true)
        |> put_session(:current_user_id, user.id)
        |> delete_session(:return_to)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> clear_session()
        |> put_flash(:error, reason)
        |> redirect(to: "/login")
    end
  end
end
