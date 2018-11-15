import React, { Component } from 'react'
import { Form, TextArea, Tab } from 'semantic-ui-react'

class CreateComment extends Component {
  renderComment() {
    return (
      <Tab.Pane>
        <Form>
          <TextArea
            className="text transparent"
            placeholder="Type your reply ..."
            rows="4" />
        </Form>
      </Tab.Pane>
    )
  }

  render() {
    const panes = [
      { menuItem: 'Reply', render: () => this.renderComment() },
      { menuItem: 'Note', render: () => <Tab.Pane>Note</Tab.Pane> },
    ]

    return (
      <Tab panes={panes} />
    )
  }
}

export default CreateComment