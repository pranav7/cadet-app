import React from 'react';
import { Button, Modal, Form } from 'semantic-ui-react';

const CreatePostModal = (props) => (
  <Modal
    trigger={props.children}
    centered={false}
    size="mini"
  >
    <Modal.Header>Create a Post</Modal.Header>
    <Modal.Content>
      <Modal.Description>
        <Form>
          <Form.Field>
            <label>Title</label>
            <input placeholder='First Name' />
          </Form.Field>
          <Form.Field>
            <label>Description</label>
            <input placeholder='Last Name' />
          </Form.Field>

          <Button type='submit'>Create</Button>
        </Form>
      </Modal.Description>
    </Modal.Content>
  </Modal>
)

export default CreatePostModal;
