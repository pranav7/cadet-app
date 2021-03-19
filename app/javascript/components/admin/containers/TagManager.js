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

    this.state = {
      tags: props.post.tags.map(x => {
        return {
          id: x.name,
          text: x.name
        }
      }),
      suggestions: []
    };
    this.handleDelete = this.handleDelete.bind(this);
    this.handleAddition = this.handleAddition.bind(this);
  }

  handleDelete(i) {
    const tag = this.state.tags[i];
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
    postApi.remove_tag(data);
  }

  handleAddition(tag) {
    this.setState(state => ({ tags: [...state.tags, tag] }), this.props.onChange);
    const postApi = new Posts(this.props.match.params.boardId, {
      postId: this.props.match.params.postId
    });
    const data = {
      tags_list: [tag]
    };
    postApi.add_tag(data);
  }

  render() {
    const { tags, suggestions } = this.state;
    return (
      <div>
        <p className="mb-2 font-bold sm:text-lg">Tags</p>
        <ReactTags classNames={{
          tag: "mx-2 my-4 p-2 bg-gray-200",
          tagInput: "my-2 p-2",
          tagInputField: "border-2 border-grey-600 rounded-md"
        }} tags={tags}
                   suggestions={suggestions}
                   handleDelete={this.handleDelete}
                   handleAddition={this.handleAddition}
                   delimiters={delimiters}
                   allowDeleteFromEmptyInput={false}
                   allowDragDrop={false}
                   inline={false}
                   placeholder={'Add new tag'}
        />
      </div>
    )
  }
}

export default withRouter(TagManager);
