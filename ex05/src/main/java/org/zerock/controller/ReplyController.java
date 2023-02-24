package org.zerock.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/replies")
@Log4j
@AllArgsConstructor
public class ReplyController {
	
	@Autowired
	private ReplyService service;
	
	@PostMapping(value="/new", consumes = "application/json"
			, produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		int insertCnt = service.register(vo);
		
		return (ResponseEntity<String>) (insertCnt == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR));
	}
	
	@GetMapping(value="/pages/{bno}/{page}", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE, MediaType.APPLICATION_XML_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("bno") Long bno, @PathVariable("page") int page){
		Criteria cri = new Criteria(page, 10);
		ReplyPageDTO list = service.getListPage(cri, bno);
		
		return new ResponseEntity<>(list, HttpStatus.OK); 
	}
	
	@GetMapping(value="/{rno}",
			produces= {MediaType.APPLICATION_JSON_UTF8_VALUE,
					MediaType.APPLICATION_XML_VALUE})
			public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
			ReplyVO vo = service.get(rno);
			
			return new ResponseEntity<>(vo, HttpStatus.OK);
	}
	
	@DeleteMapping(value="/{rno}", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		int deleteCnt = service.remove(rno);
		if(deleteCnt == 1) {
			return new ResponseEntity<>("success", HttpStatus.OK);
		} else
		return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); 
	}
	
	@RequestMapping(value="/{rno}",
			method= {RequestMethod.PUT, RequestMethod.PATCH},
			consumes="application/json",
			produces= {MediaType.APPLICATION_JSON_UTF8_VALUE, MediaType.APPLICATION_XML_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
		vo.setRno(rno);
		int updateCnt = service.modify(vo);
		if(updateCnt == 1) {
			return new ResponseEntity<>("success", HttpStatus.OK);
		} else
		return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); 
	}
}
