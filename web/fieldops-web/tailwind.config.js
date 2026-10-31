/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#1B5E20',
          light:   '#2E7D32',
          tonal:   '#A5D6A7',
          surface: '#E8F5E9',
        },
        error:   { DEFAULT: '#C62828', surface: '#FFEBEE' },
        warning: { DEFAULT: '#F57F17', surface: '#FFF8E1' },
        smkmc: {
          green:  '#1B5E20',
          maroon: '#8B1A1A',
          amber:  '#F5A623',
        },
      },
      fontFamily: {
        sans: ['Inter', 'Noto Sans', 'sans-serif'],
        devanagari: ['Noto Sans Devanagari', 'sans-serif'],
      },
      borderRadius: {
        xl: '16px',
        '2xl': '20px',
        '3xl': '24px',
      },
    },
  },
  plugins: [],
};
