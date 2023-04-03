# Tsne

From Wikipedia: [t-distributed stochastic neighbor embedding](https://en.wikipedia.org/wiki/T-distributed_stochastic_neighbor_embedding) (t-SNE) is a statistical method for visualizing high-dimensional data by giving each datapoint a location in a two or three-dimensional map.

This is an extremely low effort set of bindings to the Rust [`bhtsne`](https://docs.rs/bhtsne/latest/bhtsne/) crate.

You might use it like this:

```elixir
Mix.install(
  [
    {:exla, "~> 0.5"},
    {:nx, "~> 0.5"},
    {:rustler, "~> 0.0"},
    {:scholar, "~> 0.1"},
    {:tsne, github: "amplifiedai/tsne"}
  ],
  config: [
    nx: [default_backend: EXLA.Backend]
  ]
)

# Generate some random data.
key = Nx.Random.key(42)
{data, _} = Nx.Random.normal(key, 0, 1, shape: {1000, 256}, type: :f32)

# If your data is has high dimensionality, it's recommended to bring things
# down a fair bit using PCA before using t-SNE.
principal_components = Scholar.Decomposition.PCA.fit_transform(data, num_components: 50)

principal_components
|> Nx.to_list() # `Tsne` expects a list of lists.
|> Tsne.barnes_hut()
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tsne` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tsne, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tsne>.

