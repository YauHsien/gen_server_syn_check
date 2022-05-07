defmodule GenServerSynCheckTest do
  use ExUnit.Case
  require Logger
  doctest GenServerSynCheck

  test "gen_server:cast/2 call after gen_server:call/2" do
    {:ok, server} = GenServer.start_link(GenServerSynCheck.Server, [pid: self()])

    spawn(fn -> GenServer.call(server, :any) end)
    :timer.sleep(500)
    GenServer.cast(server, :any)

    :timer.sleep(3000)
    assert {:messages, [{:reply,:call,_,_}, {:reply,:cast,_,_}]} = Process.info(self(), :messages)
    assert [{:reply,:call,_,_}, {:reply,:cast,_,_}] = _receive(2)
  end

  defp _receive(0), do: []

  defp _receive(n) when n > 0 do
    [_receive() | _receive(n-1)]
  end

  defp _receive() do
    receive do
      msg ->
        Logger.info("#{inspect msg} received")
        msg
    end
  end
end
