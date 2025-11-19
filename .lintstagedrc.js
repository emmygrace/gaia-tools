module.exports = {
  '*.{ts,tsx}': [
    'eslint --fix',
    'prettier --write',
  ],
  '*.{js,json,md}': [
    'prettier --write',
  ],
  '*.py': [
    'ruff check --fix',
    'black',
  ],
};

