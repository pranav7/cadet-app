export const CommentTextAreaWithMentionStyles =  {
  control: {
    backgroundColor: 'transparent',

    fontSize: 14,
    fontWeight: 'normal',
  },

  highlighter: {
    overflow: 'hidden',
  },

  input: {
    margin: 0,
    minHeight: 70,
  },
  
  '&multiLine': {
    control: {
      border: 'none',
      marginBottom: 12,
    },

    highlighter: {
      padding: 9,
    },

    input: {
      padding: 9,
      minHeight: 63,
      outline: 0,
      border: 0,
    },
  },

  suggestions: {
    list: {
      backgroundColor: 'white',
      border: '1px solid rgba(0,0,0,0.15)',
      fontSize: 14,
    },

    item: {
      padding: '5px 15px',
      borderBottom: '1px solid rgba(0,0,0,0.15)',

      '&focused': {
        backgroundColor: '#cee4e5',
      },
    },
  },
};

export const MentionStyles = {
  padding: 2,
  paddingRight: 0,
  borderRadius: 4,
  marginLeft: -4,
  fontWeight: 600,
  backgroundColor: '#dff7ff',
};
