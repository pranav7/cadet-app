import React from 'react';
import { GoMarkdown } from 'react-icons/go';

const MarkdownStyling = () => (
  <a className="styling-with-markdown"
    href="https://guides.github.com/features/mastering-markdown/"
    target="_blank" >
    <GoMarkdown size="1.25em" />
    <span className="label">Markdown is supported</span>
  </a>
);

export default MarkdownStyling;
