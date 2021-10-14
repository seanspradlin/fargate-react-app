module.exports = {
  extends: ['airbnb', 'airbnb/hooks', 'next'],
  root: true,
  env: {
    jest: true,
    browser: true,
  },
  rules: {
    'jsx-a11y/label-has-associated-control': ['error', {
      required: {
        some: ['nesting', 'id'],
      },
    }],
    'react/jsx-anchor-is-valid': 'off',
    // __ CORE
    'import/prefer-default-export': 0,
    'no-console': 'warn',
    'no-nested-ternary': 0,
    'no-underscore-dangle': 0,
    'no-unused-expressions': ['error', { allowTernary: true }],
    camelcase: 0,
    'react/self-closing-comp': 1,
    'react/jsx-filename-extension': [
      1,
      {
        extensions: ['.js', '.jsx'],
      },
    ],
    // __ REACT
    'react/prop-types': 0,
    'react/destructuring-assignment': 0,
    'react/jsx-no-comment-textnodes': 0,
    'react/jsx-props-no-spreading': 0,
    'react/no-array-index-key': 0,
    'react/no-unescaped-entities': 0,
    'react/require-default-props': 0,
    // __ ACCESSIBILITY
    'jsx-a11y/label-has-for': 0,
    'jsx-a11y/anchor-is-valid': 0,
    // __ NEXT.JS
    'react/react-in-jsx-scope': 0,
  },
};
