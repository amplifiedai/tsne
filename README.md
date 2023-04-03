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
    {:tsne, "~> 0.1"}
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

## License

Copyright (c) 2023 Christopher Grainger

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

Some code this library relies on [`bhtsne`](https://github.com/frjnn/bhtsne) is MIT licensed. As required by that license, the copyright notice and permission notice are included here:

MIT License

Copyright (c) 2021 Francesco Iannelli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
