defmodule TurnstileTest do
  use ExUnit.Case
  doctest Turnstile

  setup do
    %{turnstile: turnstile()}
  end

  describe "starting" do
    test "has a state of start", %{turnstile: turnstile} do
      assert turnstile == {:locked}
    end
  end

  describe "coin()" do
    test "calling coin when state is locked", %{turnstile: turnstile} do
      open_turnstile = Turnstile.coin(turnstile)

      assert open_turnstile == {:unlocked}
    end

    test "calling coin when state is open", %{turnstile: turnstile} do
      open_turnstile = Turnstile.coin(turnstile)
      still_open_turnstile = Turnstile.coin(open_turnstile)

      assert still_open_turnstile == {:unlocked, :thanks}
    end
  end

  describe "pass()" do
    test "calling pass when state is unlocked", %{turnstile: turnstile} do
      unlocked_turnstile = Turnstile.coin(turnstile) 
      locked_turnstile = Turnstile.pass(unlocked_turnstile)

      assert locked_turnstile == {:locked}
    end

    test "calling pass when state is locked", %{turnstile: turnstile} do
      alarmed_turnstile = Turnstile.pass(turnstile)

      assert alarmed_turnstile == {:locked, :alarm}
    end

    test "calling pass when state is power_off", %{turnstile: turnstile} do
      powered_off_turnstile = Turnstile.power(turnstile)

      assert Turnstile.pass(powered_off_turnstile) == {:locked, :alarm}
    end
  end

  describe "power()" do
    test "calling power when state is locked", %{turnstile: turnstile} do
      assert Turnstile.power(turnstile) == {:power_off}
    end

    test "calling power when state is unlocked", %{turnstile: turnstile} do
      unlocked_turnstile = Turnstile.coin(turnstile)

      assert Turnstile.power(unlocked_turnstile) == {:power_off}
    end

    test "calling power when state is power_off", %{turnstile: turnstile} do
      powered_off_turnstile = Turnstile.power(turnstile)

      assert Turnstile.power(powered_off_turnstile) == {:locked}
    end
  end

  defp turnstile do
    Turnstile.start()
  end
end
