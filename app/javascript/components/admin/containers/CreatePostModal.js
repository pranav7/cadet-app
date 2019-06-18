import React, { Component } from 'react';
import { Button, Modal, Form, Input, TextArea } from 'semantic-ui-react';

import MarkdownStyling from 'Common/MarkdownStyling';

class CreatePostModal extends Component {
  constructor(props) {
    super(props);
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
            <Form>
              <Form.Field>
                <Form.Input placeholder='Title' />
              </Form.Field>
              <Form.Field>
                <Form.TextArea placeholder='Description' rows={13} />
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
