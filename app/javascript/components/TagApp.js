import React, { Component, useState } from "react";
import { BrowserRouter as Router, Route } from 'react-router-dom';
import thunkMiddleware from 'redux-thunk';
import { createStore, applyMiddleware } from "redux";
import { Provider } from 'react-redux';

import PostDetails from "AdminComponents/PostDetails";
import PostList from "AdminComponents/PostList";
import RootReducer from "Store/RootReducer";
import Select from 'react-select'
import Tags from "API/Tags";

// const store = createStore(
//   RootReducer,
//   applyMiddleware(thunkMiddleware));

export default function TagApp({ tags }) {
  const [selectedOption, setSelectedOption] = useState(null);
  const [postResults, setPostResults] = useState([]);

  const tagApi = new Tags();
  const options = tags.map(x => {
    return {
      value: x,
      label: x
    };
  });

  React.useEffect(() => {
    console.log('Option changed');
    const data = {
      tags_list: selectedOption ? selectedOption.map(x => x.value) : []
    }
    tagApi.search(data).then(response => {
      console.log(response);
      setPostResults(response.data);
    });
  }, [selectedOption])

  console.log(postResults);
  const results = postResults.map(x => {
    return (
      <div key={x.id} className={'my-5'}>
        <h2>{x.title}</h2>
        <p>Tags: {x.tag_list.map(t => <span className={'mx-3 bg-gray-200'}>{t}</span>)}</p>
      </div>
    )
  });
  return (
    <div>
      <Select     isMulti
                  defaultValue={selectedOption}
                  onChange={setSelectedOption}
                  options={options}
                  className="basic-multi-select"
                  classNamePrefix="select"
      />
      {results}
    </div>

  );
}

