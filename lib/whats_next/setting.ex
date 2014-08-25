defmodule WhatsNext.Setting do
  @ets_table :whats_next_setting

  def get(key) do
    setup
    :ets.lookup(@ets_table, key)[key]
  end

  def set(key, value) do
    setup
    :ets.insert(@ets_table, {key, value})
  end

  defp setup do
    if :ets.info(@ets_table) == :undefined do
      :ets.new(@ets_table, [:set, :public, :named_table])
      :ets.insert(@ets_table, {:file_caching, true})
    end
  end
end
