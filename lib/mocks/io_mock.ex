defmodule Elevio.FakeIO do
  @moduledoc """
  The FakeIO is an agent faking the IO
  module on the gets, write and puts functions.
  This is an agent because the return value
  of the gets function is parameterized.
  """
  use Agent

  @doc """
  Start a new IOAgent with a fixed return
  value.
  """
  def start_io(value_to_return) do
    captured_io = ""
    Agent.start_link(fn -> {value_to_return, captured_io} end, name: __MODULE__)
  end

  def reset_captured_input do
    Agent.update(__MODULE__, fn {gets_returned, _} ->
      {gets_returned, ""}
    end)
  end

  def get_input do
    Agent.get(__MODULE__, &elem(&1, 1))
  end

  def gets(_prompt) do
    Agent.get(__MODULE__, &elem(&1, 0))
  end

  def puts(message) do
    Agent.update(__MODULE__, fn {gets_return, captured_io} ->
      {gets_return, captured_io <> message <> "\n"}
    end)
  end

  def write(message) do
    Agent.update(__MODULE__, fn {gets_return, captured_io} ->
      {gets_return, captured_io <> message}
    end)
  end
end
