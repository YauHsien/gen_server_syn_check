defmodule GenServerAsynTiming do
  @moduledoc """
  Documentation for `GenServerAsynTiming`.
  """

  defmodule Server do
    use GenServer
    require Logger

    @impl true
    def init(args), do: {:ok, %{pid: Keyword.get(args,:pid)}}

    @impl true
    def handle_call(_request, _from, state) do
      :timer.sleep(20)
      at = NaiveDateTime.utc_now()
      msg = {:reply, :call, at}
      Logger.info("Call at #{inspect at}")
      {:reply, msg, state}
    end

    @impl true
    def handle_cast(_msg, state) do
      send(self(), :timing)
      {:noreply, state}
    end

    @impl true
    def handle_info(:timing, %{pid: pid} = state) do
      timing = 5000
      Logger.info("Timing #{inspect timing}")
      :timer.sleep(timing)
      ending = NaiveDateTime.utc_now()
      msg = {:reply, :timeout, ending}
      Logger.info("Send #{inspect msg}")
      send(pid, msg)
      {:stop, :normal, state}
    end
  end

end
