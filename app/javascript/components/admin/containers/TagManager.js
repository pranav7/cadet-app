import React from 'react';
import ReactDOM from 'react-dom';
import { WithContext as ReactTags } from 'react-tag-input';
import {withRouter} from "react-router-dom";
  import Posts from "API/Posts";

const KeyCodes = {
  comma: 188,
  enter: 13,
};

const delimiters = [KeyCodes.comma, KeyCodes.enter];

class TagManager extends React.Component {
  constructor(props) {
    super(props);
    console.log('Updating props');

    this.state = {
      tags: props.post.tags.map(x => {
        return {
          id: x.name,
          text: x.name
        }
      }),
      suggestions: [
        { id: 'USA', text: 'USA' },
        { id: 'Germany', text: 'Germany' },
        { id: 'Austria', text: 'Austria' },
        { id: 'Costa Rica', text: 'Costa Rica' },
        { id: 'Sri Lanka', text: 'Sri Lanka' },
        { id: 'Thailand', text: 'Thailand' }
      ]
    };
    this.handleDelete = this.handleDelete.bind(this);
    this.handleAddition = this.handleAddition.bind(this);
  }

  handleDelete(i) {
    const tag = this.state.tags[i];
    this.props.removeTag(tag);
    const { tags } = this.state;
    this.setState({
      tags: tags.filter((tag, index) => index !== i),
    });
    const postApi = new Posts(this.props.match.params.boardId, {
      postId: this.props.match.params.postId
    });
    const data = {
      tags_list: [tag]
    };
    postApi.remove_tag(data).then(response => {
      console.log(response);
    });
  }

  handleAddition(tag) {
    this.props.addTag(tag);
    this.setState(state => ({ tags: [...state.tags, tag] }), this.props.onChange);
    const postApi = new Posts(this.props.match.params.boardId, {
      postId: this.props.match.params.postId
    });
    const data = {
      tags_list: [tag]
    };
    postApi.add_tag(data).then(response => {
      console.log(response);
    });
  }

  render() {
    const { tags, suggestions } = this.state;
    return (
      <div>
        <ReactTags classNames={{
          tag: "m-4 p-2 bg-gray-200",
          tagInput: "m-6 p-2"
        }} tags={tags}
                   suggestions={suggestions}
                   handleDelete={this.handleDelete}
                   handleAddition={this.handleAddition}
                   delimiters={delimiters}
                   allowDeleteFromEmptyInput={false}
                   allowDragDrop={false}
                   inline={false}
        />
      </div>
    )
  }
}

export default withRouter(TagManager);
