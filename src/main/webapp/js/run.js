$(document).ready(function() {
    // 회원가입 폼 제출 처리
    $('#signupForm').on('submit', function(event) {
        event.preventDefault();
        
        var isValid = true;
        $('#idDiv').empty();
        $('#passwordDiv').empty();
        $('#nameDiv').empty();
        $('#emailDiv').empty();

        if (!$('#id').val()) {
            $('#idDiv').text('아이디를 입력하세요.');
            $('#id').focus();
            isValid = false;
        } else if (!$('#password').val()) {
            $('#passwordDiv').text('비밀번호를 입력하세요.');
            $('#password').focus();
            isValid = false;
        } else if (!$('#name').val()) {
            $('#nameDiv').text('이름을 입력하세요.');
            $('#name').focus();
            isValid = false;
        } else if (!$('#email').val()) {
            $('#emailDiv').text('이메일을 입력하세요.');
            $('#email').focus();
            isValid = false;
        }

        if (!isValid) return false;

        $.ajax({
            url: '../jsp/signup.jsp',
            type: 'POST',
            data: $(this).serialize(),
            success: function(response) {
                if (response.trim() === "success") {
                    alert('회원가입이 성공적으로 완료되었습니다.');
                    window.location.href = '../project/index.html';  // 메인화면으로 리다이렉트
                } else {
                    var errorMessage = response.trim().replace('Error: ', '');  // "Error: " 제거
                    alert(errorMessage);  // 서버에서 반환된 간단한 메시지 표시
                }
            },
            error: function(xhr, status, error) {
                alert("서버와의 통신 중 오류가 발생했습니다.");
            }
        });
    });

    // 로그인 폼 제출 처리
    $('#loginForm').on('submit', function(event) {
        event.preventDefault();

        var isValid = true;
        $('#idDiv').empty();
        $('#passwordDiv').empty();

        if (!$('#id').val()) {
            $('#idDiv').text('아이디를 입력하세요.');
            $('#id').focus();
            isValid = false;
        } else if (!($('#password').val())) {
            $('#passwordDiv').text('비밀번호를 입력하세요.');
            $('#password').focus();
            isValid = false;
        }

        if (!isValid) return false;

        $.ajax({
            url: '../jsp/login.jsp',
            type: 'POST',
            data: $(this).serialize(),
            success: function(response) {
                if (response.trim() === "success") {
                    alert('로그인 성공! 메인 페이지로 이동합니다.');
                    window.location.href = '../project/index.html';  // 메인화면으로 리다이렉트
                } else {
                    var errorMessage = response.trim().replace('Error: ', '');  // "Error: " 제거
                    alert(errorMessage);  // 서버에서 반환된 간단한 메시지 표시
                }
            },
            error: function(xhr, status, error) {
                alert("서버와의 통신 중 오류가 발생했습니다.");
            }
        });
    });
});
