#[allow(clippy::too_many_arguments)]
#[rustler::nif(schedule = "DirtyCpu")]
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
    metric: &str,
) -> Vec<Vec<f32>> {
    let chunked_data: Vec<&[f32]> = data.chunks(original_dims).collect();
    let mut tsne: bhtsne::tSNE<f32, &[f32]> = bhtsne::tSNE::new(&chunked_data);

    tsne.embedding_dim(embedding_dims)
        .perplexity(perplexity)
        .momentum(momentum)
        .epochs(epochs)
        .final_momentum(final_momentum)
        .learning_rate(learning_rate)
        .barnes_hut(theta, |sample_a, sample_b| match metric {
            "cosine" => cosine_distance(sample_a, sample_b).unwrap(),
            "euclidean" => euclidean_distance(sample_a, sample_b).unwrap(),
            _ => euclidean_distance(sample_a, sample_b).unwrap(),
        })
        .embedding()
        .chunks(embedding_dims.into())
        .map(|x| x.to_vec())
        .collect()
}

#[allow(clippy::too_many_arguments)]
#[rustler::nif(schedule = "DirtyCpu")]
fn exact(
    data: Vec<f32>,
    original_dims: usize,
    embedding_dims: u8,
    learning_rate: f32,
    epochs: usize,
    perplexity: f32,
    final_momentum: f32,
    momentum: f32,
    metric: &str,
) -> Vec<Vec<f32>> {
    let chunked_data: Vec<&[f32]> = data.chunks(original_dims).collect();
    let mut tsne: bhtsne::tSNE<f32, &[f32]> = bhtsne::tSNE::new(&chunked_data);

    tsne.embedding_dim(embedding_dims)
        .perplexity(perplexity)
        .momentum(momentum)
        .epochs(epochs)
        .final_momentum(final_momentum)
        .learning_rate(learning_rate)
        .exact(|sample_a, sample_b| match metric {
            "cosine" => cosine_distance(sample_a, sample_b).unwrap(),
            "euclidean" => euclidean_distance(sample_a, sample_b).unwrap(),
            _ => euclidean_distance(sample_a, sample_b).unwrap(),
        })
        .embedding()
        .chunks(embedding_dims.into())
        .map(|x| x.to_vec())
        .collect()
}

fn euclidean_distance(a: &[f32], b: &[f32]) -> Result<f32, &'static str> {
    if a.len() != b.len() {
        return Err("Input slices have different lengths.");
    }

    let squared_diff_sum: f32 = a.iter().zip(b.iter()).map(|(x, y)| (x - y).powi(2)).sum();

    Ok(squared_diff_sum.sqrt())
}

fn cosine_distance(a: &[f32], b: &[f32]) -> Result<f32, &'static str> {
    match cosine_similarity(a, b) {
        Ok(cos_similarity) => Ok(1.0 - cos_similarity),
        Err(e) => Err(e),
    }
}

fn dot_product(a: &[f32], b: &[f32]) -> f32 {
    a.iter().zip(b.iter()).map(|(x, y)| x * y).sum()
}

fn magnitude(v: &[f32]) -> f32 {
    v.iter().map(|x| x * x).sum::<f32>().sqrt()
}

fn cosine_similarity(a: &[f32], b: &[f32]) -> Result<f32, &'static str> {
    if a.len() != b.len() {
        return Err("Input slices have different lengths.");
    }

    let dot = dot_product(a, b);
    let mag_a = magnitude(a);
    let mag_b = magnitude(b);

    if mag_a == 0.0 || mag_b == 0.0 {
        return Err("One or both input slices have zero magnitude.");
    }

    Ok(dot / (mag_a * mag_b))
}

rustler::init!("Elixir.Tsne.Native", [barnes_hut, exact]);
