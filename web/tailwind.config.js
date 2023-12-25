/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './component/**/*.{js,ts,jsx,tsx,mdx}'
  ],
  theme: {
    colors : {
      'custom_bg_color' : '#EFECE2',
      'primary_card_color' : '#79C1A9',
      'primary_button_color' : '#E7B760',
      'primary_text_color': '#001219',
      'secondary_text_color' : '#2E2F2F',
      'route_label_color' : '#4B4E50'
    },
    extend: {},
  },
  plugins: [],
}

