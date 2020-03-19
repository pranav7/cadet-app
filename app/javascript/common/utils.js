function fallbackCopyTextToClipboard(text) {
  var textArea = document.createElement("textarea");
  textArea.value = text;
  document.body.appendChild(textArea);
  textArea.focus();
  textArea.select();

  return new Promise((resolve, reject) => {
    try {
      var successful = document.execCommand('copy');
      var msg = successful ? 'successful' : 'unsuccessful';
      resolve();
    } catch (err) {
      console.error('Error Occured while copying to clipboard', err);
      reject();
    }
    document.body.removeChild(textArea); 
  });
}

export function copyTextToClipboard(text) {
  if (!navigator.clipboard) {
    return fallbackCopyTextToClipboard(text);
  }
  return navigator.clipboard.writeText(text).then(_ => {}, function(err) {
    console.error('Error Occured while copying to clipboard', err);
  });
}