const bookmark = $('#bookmark');
const addCommentBtn = $('#add-comment-btn');
const commentContent = $('#comment-content');
const commentSection = $('#comment-section');
let reid, userid, toast;
$(document).ready(() => {
    reid = window.location.pathname.replace('/post/', '');
    userid = getCookie('userID');
    toast = Toast;
});

const sendBookMark = async () => {
    if (!userid) return;
    if (!reid) return;
    const res = await fetch('/post/bookmark', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ userid, reid }),
    });
    const data = await res.json();
    if (data[0].savePost_id_exists) {
        return Toast.fire({ title: 'Bạn đã hủy lưu tin', icon: 'warning' });
    } else {
        return Toast.fire({
            title: 'Bạn đã lưu tin thành công',
            icon: 'success',
        });
    }
};
const addComment = async (body) => {
    const res = await fetch(`/post/${reid}/comment`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
    });
    const data = await res.json();
    if (data[0][0] === 0) {
        Toast.fire({
            title: 'Bạn đã bình luận bài post này',
            icon: 'warning',
        });
        return commentContent.val('');
    }
    window.location.reload();
    return data;
};
bookmark.on('click', () => sendBookMark());
addCommentBtn.on('click', () => addComment({ reid, userid, content: commentContent.val() }));
