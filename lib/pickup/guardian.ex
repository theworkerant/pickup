defmodule Pickup.Guardian do
  use Guardian, otp_app: :pickup

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Pickup.Users.get!(id)
    {:ok, resource}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end

defmodule Pickup.Guardian.ErrorHandler do
  import Plug.Conn

  use PickupWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    conn
    |> put_session(:return_to, current_url(conn))
    |> redirect(to: "/login")
  end

  def auth_error(conn, {:already_authenticated, _reason}, _opts) do
    conn
    |> redirect(to: "/")
  end

  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end

defmodule Pickup.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :pickup,
    error_handler: Pickup.Guardian.ErrorHandler,
    module: Pickup.Guardian

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
