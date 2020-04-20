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
      border: '1px solid #e2e2e2',
      borderRadius: 5,
    },

    item: {
      padding: '5px 15px',
      borderBottom: '1px solid #e2e2e2',
      color: '#212121',

      '&focused': {
        backgroundColor: '#4a90e2',
        color: '#fff !important',
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
