# GenServer synchronous check
... to assert if a call `gen_server:cast/2` is blocked by another call `gen_server:call/2`.

## Summary

Yes.

## Run

```elixir
$ mix test
```

And check following files:
- lib/gen_server_syn_check.ex
- test/gen_server_syn_check_test.exs
