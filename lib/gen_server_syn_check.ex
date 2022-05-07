defmodule GenServerSynCheck do
  @moduledoc """
  Documentation for `GenServerSynCheck`.
  """

  defmodule Server do
    use GenServer
    require Logger

    @impl true
    def init(args), do: {:ok, %{pid: Keyword.get(args,:pid)}}

    @impl true
    def handle_call(_request, _from, %{pid: pid} = state) do
      Logger.info("Call...")
      start = NaiveDateTime.utc_now()
      :timer.sleep(2000)
      ending = NaiveDateTime.utc_now()
      msg = {:reply, :call, start, ending}
      Logger.info("Send #{inspect msg}")
      send(pid, msg)
      {:noreply, state}
    end

    @impl true
    def handle_cast(_msg, %{pid: pid} = state) do
      Logger.info("Cast...")
      start = NaiveDateTime.utc_now()
      :timer.sleep(1000)
      ending = NaiveDateTime.utc_now()
      msg = {:reply, :cast, start, ending}
      Logger.info("Send #{inspect msg}")
      send(pid, msg)
      {:noreply, state}
    end
  end

end
