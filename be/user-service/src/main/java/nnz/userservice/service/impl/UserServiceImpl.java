package nnz.userservice.service.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import nnz.userservice.dto.MessageDTO;
import nnz.userservice.entity.VerifyNumber;
import nnz.userservice.repository.VerifyNumberRepository;
import nnz.userservice.service.SmsSender;
import nnz.userservice.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = false)
public class UserServiceImpl implements UserService {

    private final SmsSender smsSender;
    private final VerifyNumberRepository verifyNumberRepository;

    @Override
    @Transactional
    public void sendVerifySms(String to) throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException, InvalidKeyException, JsonProcessingException {
        String randomNumber = createRandomNumber();

        // 인증번호를 문자로 전송
        // TODO: NCP-SMS 인증문제 해결 후 문자 보내도록 수정
        MessageDTO messageDTO = MessageDTO.builder()
                .to(to)
                .content(randomNumber)
                .build();
//        smsSender.sendMessage(messageDTO);

        // 인증번호 redis에 저장
        // 인증 확인 및 회원가입시 인증 여부 확인하기 위해
        VerifyNumber verifyNumber = VerifyNumber.builder()
                .phone(to)
                .verifyNumber(Integer.parseInt(randomNumber))
                .isVerify(false)
                .build();
        verifyNumberRepository.save(verifyNumber);
        log.info("레디스에 인증정보 저장: {}", verifyNumber);
    }

    public static String createRandomNumber() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(999999));
    }
}
