defmodule Tsne do
  @moduledoc """
  t-distributed stochastic neighbor embedding (t-SNE) is a statistical method for 
  visualizing high-dimensional data in two or three dimensions.

  This library provides bindings to fast exact and
  [Barnes-Hut](http://lvdmaaten.github.io/publications/papers/JMLR_2014.pdf)
  implementations of t-SNE in Rust using the 
  [`bhtsne`](https://github.com/lvdmaaten/bhtsne) crate.
  """

  alias Tsne.Native

  @tsne_options [
    embedding_dimensions: [type: :integer, default: 2, doc: "Dimension of the embedded space."],
    learning_rate: [
      type: :float,
      default: 200.0,
      doc:
        "The learning rate for t-SNE is usually in the range [10.0, 1000.0]. If the learning rate is too high, the data may look like a ‘ball’ with any point approximately equidistant from its nearest neighbours. If the learning rate is too low, most points may look compressed in a dense cloud with few outliers. If the cost function gets stuck in a bad local minimum increasing the learning rate may help."
    ],
    epochs: [
      type: :integer,
      default: 1000,
      doc: "Maximum number of iterations for the optimization. Should be at least 250."
    ],
    perplexity: [
      type: :float,
      default: 30.0,
      doc:
        "The perplexity is related to the number of nearest neighbors that is used in other manifold learning algorithms. Larger datasets usually require a larger perplexity. Consider selecting a value between 5 and 50. Different values can result in significantly different results. The perplexity must be less than the number of samples."
    ],
    final_momentum: [
      type: :float,
      default: 0.8,
      doc:
        "The value for momentum after the initial early exaggeration phase. See`momentum` for more info."
    ],
    momentum: [
      type: :float,
      default: 0.5,
      doc:
        "Gradient descent with momentum keeps a sum exponentially decaying weights from previous iterations, speeding up convergence. In early stages of the optimization, this is typically set to a lower value (0.5 in most implementations) since points generally move around quite a bit in this phase and increased after the initial early exaggeration phase (typically to 0.8, see: `final_momentum`) to speed up convergence."
    ],
    metric: [
      type: {:in, [:euclidean, :cosine]},
      default: :euclidean,
      doc: "The distance metric to use. Must be either `:euclidean` or `:cosine`."
    ]
  ]

  @barnes_hut_options @tsne_options
                      |> Keyword.merge(
                        theta: [
                          type: :float,
                          default: 0.5,
                          doc: "The tradeoff parameter between accuracy (0) and speed (1)."
                        ]
                      )
                      |> NimbleOptions.new!()

  @doc """
  Barnes Hut t-SNE.

  [Barnes-Hut](http://lvdmaaten.github.io/publications/papers/JMLR_2014.pdf) is a 
  tree-based algorithm for accelerating t-SNE. It runs in O(NlogN) time (while exact 
  runs in O(N^2)) time.

  ## Options
  #{NimbleOptions.docs(@barnes_hut_options)}
  """
  def barnes_hut(data, opts \\ []) do
    opts = NimbleOptions.validate!(opts, @barnes_hut_options)

    original_dimensions = data |> List.first() |> length()
    data = List.flatten(data)

    Native.barnes_hut(
      data,
      original_dimensions,
      opts[:embedding_dimensions],
      opts[:learning_rate],
      opts[:epochs],
      opts[:perplexity],
      opts[:theta],
      opts[:final_momentum],
      opts[:momentum],
      "#{opts[:metric]}"
    )
  end

  @exact_options NimbleOptions.new!(@tsne_options)

  @doc """
  Exact t-SNE.

  ## Options
  #{NimbleOptions.docs(@barnes_hut_options)}
  """
  def exact(data, opts \\ []) do
    opts = NimbleOptions.validate!(opts, @exact_options)

    original_dimensions = data |> List.first() |> length()
    data = List.flatten(data)

    Native.exact(
      data,
      original_dimensions,
      opts[:embedding_dimensions],
      opts[:learning_rate],
      opts[:epochs],
      opts[:perplexity],
      opts[:final_momentum],
      opts[:momentum],
      "#{opts[:metric]}"
    )
  end
end
