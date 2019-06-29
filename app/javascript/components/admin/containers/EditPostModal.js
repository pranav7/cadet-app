import React, { Component } from 'react';

class EditPostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      title: "",
      description: "",
      titleHasError: false,
      modalOpen: false
    }
  }
}
