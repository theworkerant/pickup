defmodule Pickup.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  import Nostrum.Struct.Embed

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, ws_state}) do
    if System.get_env("MIX_ENV") == "test" do
      :ignore
    else
      case msg.content do
        "ping!" ->
          embed =
            %Nostrum.Struct.Embed{}
            |> put_title("testing embed update .... wait for it...")
            |> put_description("
```
Frisbee says,

> Let's battle and hope we don't get team switch
> ed or headshot by hackers.
>
> Some link
>

Adamant Ricochet ................................
Game ............................ Team Fortress 2
Time .............. Sun 07:00 PM-08:00 PM Eastern

⊱=================== PLAYERS ===================⊰

|    Frisbee    |     Ergle     | Nebuchadnezz… |
|     Ensy      |  - reserve -     - reserve -

⊱===============================================⊰
```


I'll play Ringer                              (?)
  ↳ Get notified 15 minutes before start if a
     slot is still open— no obligation to play



Suggest Alternate Time
[15:30](http://google.com)____________[16:00](http://google.com)____________[16:30](http://google.com)____▞____[17:30](http://google.com)____________[18:00](http://google.com)____________[18:30](http://google.com)

```
! Frisbee would rather ................. 17:10pm
↳ and Ensy, Evan, Me too!

! Eviscerator would rather ............. 06:30pm
↳ Me too!
```
")
            |> put_footer("pickup.fathom.digital")

          {:ok, response} = Api.create_message(msg.channel_id, %{embed: embed})

        # Process.send_after(self(), :update1, 1000)

        # Api.edit_message(msg.channel_id, response.id, embed: embed2)

        _ ->
          :ignore
      end
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
