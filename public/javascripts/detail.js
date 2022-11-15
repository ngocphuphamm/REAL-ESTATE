const bookmark = $("#bookmark");
const addCommentBtn = $("#add-comment-btn");
const commentContent = $("#comment-content");
const commentSection = $("#comment-section");
let reid, userid, swal;
$(document).ready(() => {
	reid = window.location.pathname.replace("/post/", "");
	userid = getCookie("userID");
	swal = Swal;
});

const sendBookMark = async () => {
	if (!userid) return;
	if (!reid) return;
	const res = await fetch("/post/bookmark", {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
		},
		body: JSON.stringify({ userid, reid }),
	});
	const data = await res.json();
	return data;
};
const addComment = async (body) => {
	const res = await fetch(`/post/${reid}/comment`, {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
		},
		body: JSON.stringify(body),
	});
	const data = await res.json();
	if (!data) return;
	window.location.reload();
	return data;
};
bookmark.on("click", () => sendBookMark());
addCommentBtn.on("click", () =>
	addComment({ reid, userid, content: commentContent.val() })
);
