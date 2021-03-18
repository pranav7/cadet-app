import React, { Component, useState } from "react";
import Select from 'react-select'
import Tags from "API/Tags";
import {BrowserRouter as Router, Route, withRouter} from 'react-router-dom';
import {Loader} from "./Loader";
import TagPostListItem from "./admin/TagPostListItem";

export default function TagApp({ tags }) {
  const [selectedOption, setSelectedOption] = useState(null);
  const [postResults, setPostResults] = useState([]);
  const [loading, setLoading] = useState(true);

  const tagApi = new Tags();
  const options = tags.map(x => {
    return {
      value: x,
      label: x
    };
  });

  React.useEffect(() => {
    setLoading(true);
    const data = {
      tags_list: selectedOption ? selectedOption.map(x => x.value) : []
    }
    tagApi.search(data).then(response => {
      setPostResults(response.data);
      setLoading(false);
    });
  }, [selectedOption])

  const results = <div className="my-4 post-list-item-container bg-white">
    {postResults.map(post => (
      <React.Fragment key={post.id}>
        <TagPostListItem
          key={post.id}
          post={post}
        />
      </React.Fragment>
    ))}
  </div>


  return (
    <Router>
      <div className={'m-8'}>
        <h2 className={'text-xl text-center font-semibold'}>Tag Search</h2>
        <Select isMulti
                    defaultValue={selectedOption}
                    onChange={setSelectedOption}
                    options={options}
                    className="basic-multi-select"
                    classNamePrefix="select"
                    placeholder={"Select tags..."}
        />
        {loading ? <Loader /> : results}
      </div>
    </Router>
  );
}
