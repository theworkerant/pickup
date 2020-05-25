defmodule Pickup.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  import Nostrum.Struct.Embed

  def start_link do
    Consumer.start_link(__MODULE__)
    # send(self(), :init, )
  end

  def handle_event({:init, msg, _ws_state}) do
  end

  def handle_event({:MESSAGE_CREATE, msg, ws_state}) do
    IO.inspect(ws_state)

    case msg.content do
      "ping!" ->
        embed =
          %Nostrum.Struct.Embed{}
          |> put_title("testing embed update .... wait for it...")
          |> put_description("lots of slots open! [ ] [ ] [ ] [ ] [ ] [ ]")
          |> put_footer("pickup.fathom.digital")

        {:ok, response} = Api.create_message(msg.channel_id, %{embed: embed})

      # Process.send_after(self(), :update1, 1000)

      # Api.edit_message(msg.channel_id, response.id, embed: embed2)

      _ ->
        :ignore
    end
  end

  # def handle_event({:update1, _, ws_state}) do
  #   embed =
  #     embed
  #     |> put_description("only some slots open now! [x] [ ] [ ] [ ] [ ] [ ]")
  #
  #   Api.edit_message(msg.channel_id, response.id, embed: embed)
  # end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end
end
