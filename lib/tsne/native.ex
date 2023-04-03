defmodule Tsne.Native do
  use Rustler,
    otp_app: :tsne,
    crate: :tsne_native

  def barnes_hut(
        _data,
        _original_dims,
        _embedding_dims,
        _learning_rate,
        _epochs,
        _perplexity,
        _theta,
        _final_momentum,
        _momentum,
        _metric
      ),
      do: :erlang.nif_error(:nif_not_loaded)

  def exact(
        _data,
        _original_dims,
        _embedding_dims,
        _learning_rate,
        _epochs,
        _perplexity,
        _final_momentum,
        _momentum,
        _metric
      ),
      do: :erlang.nif_error(:nif_not_loaded)
end
