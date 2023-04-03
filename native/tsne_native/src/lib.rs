#[rustler::nif]
fn barnes_hut(
    data: Vec<f32>,
    original_dims: usize,
    embedding_dims: u8,
    learning_rate: f32,
    epochs: usize,
    perplexity: f32,
    theta: f32,
    final_momentum: f32,
    momentum: f32,
) -> Vec<Vec<f32>> {
    let chunked_data: Vec<&[f32]> = data.chunks(original_dims).collect();
    let mut tsne: bhtsne::tSNE<f32, &[f32]> = bhtsne::tSNE::new(&chunked_data);

    tsne.embedding_dim(embedding_dims)
        .perplexity(perplexity)
        .momentum(momentum)
        .epochs(epochs)
        .final_momentum(final_momentum)
        .learning_rate(learning_rate)
        .barnes_hut(theta, |sample_a, sample_b| {
            sample_a
                .iter()
                .zip(sample_b.iter())
                .map(|(a, b)| (a - b).powi(2))
                .sum::<f32>()
                .sqrt()
        })
        .embedding()
        .chunks(embedding_dims.into())
        .map(|x| x.to_vec())
        .collect()
}

rustler::init!("Elixir.Tsne.Native", [barnes_hut]);
