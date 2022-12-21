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
    try {
        if (!userid || !reid) return;
        const res = await fetch('/post/bookmark', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ userid, reid }),
        });
        const data = await res.json();
        const response = data[0];
        if (!response) throw new Error(data.message);
        const conditionShowToast = response && response.savePost_id_exists;
        if (conditionShowToast) {
            toast.fire({ title: 'Bạn đã hủy lưu tin', icon: 'warning' });
        } else {
            toast.fire({
                title: 'Bạn đã lưu tin thành công',
                icon: 'success',
            });
        }
        return window.location.reload();
    } catch (err) {
        toast.fire({ title: err.message, icon: 'error' });
    }
};
const addComment = async (body) => {
    try {
        const res = await fetch(`/post/${reid}/comment`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
        });
        const data = await res.json();
        if (!data.success) {
            return toast.fire({
                title: data.message,
                icon: 'warning',
            });
        }
        const response = data.body[0];
        if (response[0] === 0) {
            toast.fire({
                title: 'Bạn đã bình luận bài post này hoặc nội dung comment không phù hợp',
                icon: 'warning',
            });
            return commentContent.val('');
        }
        window.location.reload();
        return data;
    } catch (err) {
        toast.fire({ title: err.message, icon: 'error' });
    }
};
bookmark.on('click', () => sendBookMark());
addCommentBtn.on('click', () => addComment({ reid, userid, content: commentContent.val() }));
