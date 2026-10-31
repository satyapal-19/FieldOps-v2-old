/**
 * Face matching rules as pure functions (no model, database or clock).
 * Embeddings are compared by cosine similarity; thresholds are calibrated on pilot data
 * (see the face model selection doc) and passed in from configuration.
 */

export type Embedding = ArrayLike<number>;

export interface MatchDecision {
  matched: boolean;
  score: number;
  threshold: number;
}

export interface Candidate {
  staffId: string;
  embeddings: Embedding[];
}

export interface RankedCandidate {
  staffId: string;
  score: number;
}

export function l2Normalize(vector: Embedding): number[] {
  let sumSq = 0;
  for (let i = 0; i < vector.length; i++) sumSq += vector[i] * vector[i];
  const norm = Math.sqrt(sumSq);
  if (norm === 0) throw new Error('Cannot normalise a zero vector');
  return Array.from(vector, (v) => v / norm);
}

/** Cosine similarity in [-1, 1]; works on raw or already-normalised vectors. */
export function cosineSimilarity(a: Embedding, b: Embedding): number {
  if (a.length !== b.length) {
    throw new Error(`Embedding sizes differ: ${a.length} vs ${b.length}`);
  }
  let dot = 0;
  let normA = 0;
  let normB = 0;
  for (let i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }
  if (normA === 0 || normB === 0) return 0;
  return dot / (Math.sqrt(normA) * Math.sqrt(normB));
}

/** Best score of a probe against a person's enrolment embeddings (several photos each). */
export function bestScore(probe: Embedding, enrolled: Embedding[]): number {
  if (enrolled.length === 0) return -1;
  return Math.max(...enrolled.map((e) => cosineSimilarity(probe, e)));
}

/** 1-to-1: does the probe match this person? */
export function decideMatch(probe: Embedding, enrolled: Embedding[], threshold: number): MatchDecision {
  const score = bestScore(probe, enrolled);
  return { matched: score >= threshold, score: round(score), threshold };
}

/** 1-to-N within a small group (an inspector's team): candidates ranked best first. */
export function rankCandidates(probe: Embedding, candidates: Candidate[]): RankedCandidate[] {
  return candidates
    .map((c) => ({ staffId: c.staffId, score: round(bestScore(probe, c.embeddings)) }))
    .sort((a, b) => b.score - a.score);
}

/**
 * Picks the top candidate only if it clears the threshold AND beats the runner-up by a
 * margin, so two similar-looking team members are never confused silently.
 */
export function pickCandidate(
  ranked: RankedCandidate[],
  threshold: number,
  minMargin = 0.05,
): RankedCandidate | null {
  const [top, second] = ranked;
  if (!top || top.score < threshold) return null;
  if (second && top.score - second.score < minMargin) return null;
  return top;
}

function round(value: number): number {
  return Math.round(value * 10_000) / 10_000;
}
