// ESLint flat config for the FieldOps backend.
import js from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  { ignores: ['dist/**', 'coverage/**', 'node_modules/**'] },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      'no-console': 'error',
      // Modules talk to each other only through exported services, never repositories.
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: ['../*/*.repository', '../../modules/*/*.repository'],
              message: 'Import another module\'s service, not its repository.',
            },
          ],
        },
      ],
    },
  },
);
