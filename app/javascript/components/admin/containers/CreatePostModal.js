import React, { Component } from 'react';
import { Button, Modal, Form, Input, TextArea } from 'semantic-ui-react';

import MarkdownStyling from 'Common/MarkdownStyling';

class CreatePostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      title: {
        value: '',
        hasError: false
      },
      description: {
        value: '',
        hasError: false
      }
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(e, { name, value }) {
    this.setState({ [name]: { ...this.state[name], value } });
  }

  handleSubmit() {
    if (this.state.title.value === '') {
      this.setState({
        title: {
          ...this.state.title,
          hasError: true
        }
      });
    } else {
      this.setState({
        title: {
          ...this.state.title,
          hasError: false
        }
      });
    }

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
                  error={this.state.title.hasError}
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
