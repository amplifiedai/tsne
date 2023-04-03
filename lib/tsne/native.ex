defmodule Tsne.Native do
  mix_config = Mix.Project.config()
  version = mix_config[:version]
  github_url = mix_config[:package][:links]["GitHub"]

  use RustlerPrecompiled,
    otp_app: :tsne,
    crate: :tsne_native,
    version: version,
    base_url: "#{github_url}/releases/download/v#{version}",
    force_build: System.get_env("TSNE_BUILD") in ["1", "true"]

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
