defmodule Tsne do
  @moduledoc """
  Documentation for `Tsne`.
  """

  alias Tsne.Native

  @doc """
  Barnes Hut t-SNE.
  """
  def barnes_hut(data, opts \\ []) do
    opts =
      Keyword.validate!(opts,
        embedding_dims: 2,
        learning_rate: 200.0,
        epochs: 1000,
        perplexity: 20.0,
        theta: 0.5,
        final_momentum: 0.8,
        momentum: 0.5
      )

    original_dims = data |> List.first() |> length()
    data = List.flatten(data)

    Native.barnes_hut(
      data,
      original_dims,
      opts[:embedding_dims],
      opts[:learning_rate],
      opts[:epochs],
      opts[:perplexity],
      opts[:theta],
      opts[:final_momentum],
      opts[:momentum]
    )
  end
end
