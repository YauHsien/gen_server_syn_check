defmodule MyApplication do
	use Application

  def start(_type, _args) do

    children = [
      {Registry, keys: :unique, name: MyReg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MySup)
  end
end
