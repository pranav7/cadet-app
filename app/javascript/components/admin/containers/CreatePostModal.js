import React, { Component } from 'react';
import { Button, Modal, Form, Input, TextArea } from 'semantic-ui-react';

import MarkdownStyling from 'Common/MarkdownStyling';

class CreatePostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      title: '',
      description: ''
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(e, { name, value }) {
    this.setState({ [name]: value });
  }

  handleSubmit() {
    console.log("Submitted", this.state.title, this.state.description);
  }

  render() {
    return (
      <Modal
        trigger={this.props.children}
        centered={false}
        size="tiny"
      >
        <Modal.Header>Create a Post</Modal.Header>
        <Modal.Content>
          <Modal.Description>
            <Form onSubmit={this.handleSubmit}>
              <Form.Field>
                <Form.Input
                  name="title"
                  placeholder='Title'
                  onChange={this.handleChange}
                />
              </Form.Field>
              <Form.Field>
                <Form.TextArea
                  name="description"
                  placeholder='Description'
                  rows={13}
                  onChange={this.handleChange}
                />
              </Form.Field>

              <Button type='submit'>Create</Button>
              <MarkdownStyling />
            </Form>
          </Modal.Description>
        </Modal.Content>
      </Modal>
    );
  }
}

export default CreatePostModal;
