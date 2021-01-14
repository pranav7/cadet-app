import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "text" ]

  startUpload(evt) {
    const files = evt.target.files;
    if (files.length > 0) {
      for (const file of files) {
        if (validFileType(file)) {
          sendFileData(file, this.textTarget.textContent);
        } else {
          alert('Invalid file type. Only accepting types: ' + fileTypes.join(", "));
        }
      }
    }

  }
}


const fileTypes = [
  "image/apng",
  "image/bmp",
  "image/gif",
  "image/jpeg",
  "image/pjpeg",
  "image/png",
  "image/svg+xml",
  "image/tiff",
  "image/webp",
  "image/x-icon"
];

function validFileType(file) {
  return fileTypes.includes(file.type);
}

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}


const sendFileData = (file, textAreaId) => {
  const id = uuidv4();
  const tempText = `![Uploading ${file.name}...]()`;

  // Add temporary link text
  $(textAreaId).val(function () {
    return this.value + '\n' + tempText;
  });

  var fd = new FormData();
  fd.append('file', file, id);
  const response = fetch('/images', {
    method: 'POST',
    body: fd,
    headers: {
      'Accept': "application/json",
    }
  }).then(response => response.json())
  .then(data => {
    $(textAreaId).val(function () {
      const markdownURL = `![${file.name}](${data.url})`;
      return this.value.replace(tempText, markdownURL);
    });
  });
}
