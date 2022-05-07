defmodule GenServerAsynTimingTest do
  use ExUnit.Case
  require Logger
  doctest GenServerAsynTiming

  test "timing" do
    via = {:via, Registry, {MyReg, :hello}}
    {:ok, server} = GenServer.start_link(GenServerAsynTiming.Server, [pid: self()], name: via)

    assert [{pid, nil}] = Registry.lookup(MyReg, :hello)
    assert Process.alive?(pid)

    GenServer.cast(via, :any)
    result = GenServer.call(server, :any)

    assert {:reply, :call, _} = result
    :timer.sleep(6000)
    assert {:messages, [{:reply, :timeout, _}]} = Process.info(self(), :messages)
    assert [] = Registry.lookup(MyReg, :hello)
  end
end
