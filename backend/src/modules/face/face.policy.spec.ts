import {
  bestScore,
  cosineSimilarity,
  decideMatch,
  l2Normalize,
  pickCandidate,
  rankCandidates,
} from './face.policy';

describe('face policy', () => {
  it('cosine similarity is 1 for same direction, 0 for orthogonal, -1 for opposite', () => {
    expect(cosineSimilarity([1, 2, 3], [2, 4, 6])).toBeCloseTo(1, 6);
    expect(cosineSimilarity([1, 0], [0, 1])).toBeCloseTo(0, 6);
    expect(cosineSimilarity([1, 0], [-1, 0])).toBeCloseTo(-1, 6);
  });

  it('rejects embeddings of different sizes', () => {
    expect(() => cosineSimilarity([1, 2], [1, 2, 3])).toThrow(/sizes differ/);
  });

  it('normalises vectors to unit length', () => {
    const v = l2Normalize([3, 4]);
    expect(v[0]).toBeCloseTo(0.6, 6);
    expect(v[1]).toBeCloseTo(0.8, 6);
    expect(() => l2Normalize([0, 0])).toThrow();
  });

  it('uses the best of several enrolment photos', () => {
    expect(bestScore([1, 0], [[0, 1], [1, 0.1]])).toBeGreaterThan(0.99);
    expect(bestScore([1, 0], [])).toBe(-1);
  });

  it('decides a 1-to-1 match against the threshold', () => {
    expect(decideMatch([1, 0], [[1, 0.2]], 0.9).matched).toBe(true);
    expect(decideMatch([1, 0], [[0.2, 1]], 0.9).matched).toBe(false);
  });

  it('ranks a team best first and picks only a clear winner', () => {
    const ranked = rankCandidates([1, 0], [
      { staffId: 'ramesh', embeddings: [[0.3, 1]] },
      { staffId: 'sunita', embeddings: [[1, 0.05]] },
    ]);
    expect(ranked[0].staffId).toBe('sunita');
    expect(pickCandidate(ranked, 0.5)?.staffId).toBe('sunita');
  });

  it('refuses a winner that is too close to the runner-up', () => {
    const ranked = [
      { staffId: 'a', score: 0.8 },
      { staffId: 'b', score: 0.78 },
    ];
    expect(pickCandidate(ranked, 0.5)).toBeNull();
    expect(pickCandidate([{ staffId: 'a', score: 0.4 }], 0.5)).toBeNull();
  });
});
