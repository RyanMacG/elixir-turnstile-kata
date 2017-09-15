defmodule Turnstile do
  def start do
    {:locked}
  end

  def coin(turnstile) do
    unlock(turnstile)
  end

  def pass(turnstile) do
    lock(turnstile)
  end

  def power({:power_off}) do
    {:locked}
  end

  def power(_) do
    {:power_off}
  end

  defp lock({:unlocked}) do
    {:locked}
  end

  defp lock(_) do
    {:locked, :alarm}
  end

  defp unlock({:locked}) do
    {:unlocked}
  end

  defp unlock({:unlocked}) do
    {:unlocked, :thanks}
  end
end
