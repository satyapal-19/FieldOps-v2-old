import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./app/**/*.{ts,tsx}', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        smkc: {
          DEFAULT: '#1F3864',
          light: '#2E5597',
        },
      },
    },
  },
  plugins: [],
};

export default config;
