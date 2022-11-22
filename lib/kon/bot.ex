defmodule Kon.Bot do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  @impl true
  def init(opts) do
    {key, _opts} = Keyword.pop!(opts, :bot_key)

    case Telegram.Api.request(key, "getMe") do
      {:ok, me} ->
        IO.inspect(me, label: "kon_bot")
        Logger.info("Bot successfully self-identified #{me["username"]}")

        state = %{
          bot_key: key,
          me: me,
          last_seen: -2
        }

        next_loop()

        {:ok, state}

      error ->
        Logger.error("Bot failed to self-identified #{inspect(error)}")
    end
  end

  @impl true
  def handle_info(:check, %{bot_key: key, last_seen: last_seen} = state) do
      state =
      key
      |> Telegram.Api.request("getUpdates", offset: last_seen + 1, timeout: 30)
      |> case do
          # empty, timeout, state returned unchanged
          {:ok, []} -> state
          # a response with content
          {:ok, updates} -> handle_updates(updates, last_seen)

          # update last_seen state so we only get new updates
          %{state | last_seen: last_seen}
      end

      # re-trigger the loop behavior
      next_loop()
      {:noreply, state}
  end

  ## private functions

  defp handle_updates(updates, last_seen) do
      updates
      # process updates
      |> Enum.map(fn update ->
        Logger.info("update received: #{inspect(update)}")
        broadcast(update)

        update["update_id"]
      end)
      |> Enum.max(fn -> last_seen end)
  end

  defp broadcast(update) do
      Phoenix.PubSub.broadcast!(Kon.PubSub, "bot_update", {:update, update})
  end

  defp next_loop do
      Process.send_after(self(), :check, 5000)
  end
end
