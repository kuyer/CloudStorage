package cn.im47.cloud.storage.common.service.file.impl;

import cn.im47.cloud.storage.common.dao.node.NodeMapper;
import cn.im47.cloud.storage.common.dao.file.UploadedFileMapper;
import cn.im47.cloud.storage.common.entity.file.UploadedFile;
import cn.im47.cloud.storage.common.service.file.UploadedFileManager;
import cn.im47.cloud.storage.utilities.file.FileHandler;
import cn.im47.cloud.storage.utilities.upload.common.UploadFile;
import org.apache.commons.net.ntp.TimeStamp;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 文件 Manager 实现类
 * <p/>
 * User: baitao.jibt@gmail.com
 * Date: 12-7-16
 * Time: 下午10:59
 */
@Component
public class UploadedFileManagerImpl implements UploadedFileManager {

    private static final Logger logger = LoggerFactory.getLogger(UploadedFileManagerImpl.class);

    private static final String FILE_PATH = "D:/";

    private static final String UPLOADED_PATH = "D:/sources/";

    private UploadedFileMapper uploadedFileMapper;

    private NodeMapper nodeMapper;

    @Override
    public UploadedFile get(String appKey, Long id) {
        return uploadedFileMapper.get(appKey, id);
    }

    @Override
    public UploadedFile get(String appKey, String fileKey) {
        return uploadedFileMapper.getByFileKey(appKey, fileKey);
    }

    @Override
    public List<UploadedFile> getByNode(String appKey, Long id, int offset, int limit) {
        return uploadedFileMapper.getByNode(appKey, id, offset, limit);
    }

    @Override
    public long countByNode(String appKey, Long id) {
        return uploadedFileMapper.countByNode(appKey, id);
    }

    @Override
    public int save(String appKey, UploadedFile object) {
        return uploadedFileMapper.save(appKey, object);
    }

    @Override
    public UploadedFile save(String appKey, MultipartFile file) {
        String fileName = file.getOriginalFilename();
        File fileOnServer = UploadFile.uploadFile(file, new File(UPLOADED_PATH + fileName));

        /* 对文件md5 */
        String suffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
        int fileSize = ((Long) fileOnServer.length()).intValue();
        String md5 = FileHandler.MD5(fileOnServer);

        String timeStamp = new TimeStamp(new Date()).toString();
        int length = timeStamp.length();
        timeStamp = timeStamp.substring(length - 8, length);
        String fileKey = md5 + timeStamp;
        String crc32 = FileHandler.CRC32(fileOnServer);

        /* 移动文件到文件目录 */
        FileHandler.moveFile(fileOnServer, new File(FILE_PATH + fileKey + "." + suffix));

        /* 入库 */
        UploadedFile uploadedFile = new UploadedFile();
        uploadedFile.setNode(nodeMapper.get(appKey, 1L));
        uploadedFile.setFileKey(fileKey + "." + suffix);
        uploadedFile.setCustomName(fileName);
        uploadedFile.setRealName(fileName);
        uploadedFile.setSuffix(suffix);
        uploadedFile.setSize(fileSize);
        uploadedFile.setMd5(md5);
        uploadedFile.setCRC(crc32);
        uploadedFile.setShared(false);
        uploadedFile.setStatus(true);
        uploadedFile.setDeleted(true);
        if (uploadedFileMapper.save(appKey, uploadedFile) > 0) {
            return uploadedFile;
        } else {
            return null;
        }
    }

    @Override
    public int update(String appKey, UploadedFile object) {
        return uploadedFileMapper.update(appKey, object);
    }

    @Override
    public int updateBool(String appKey, String fileKey, String column) {
        return uploadedFileMapper.updateBool(appKey, fileKey, column);
    }

    @Override
    public long updateDownload(String appKey, String fileKey) {
        return uploadedFileMapper.updateDownload(appKey, fileKey);
    }

    @Override
    public int delete(String appKey, String fileKey) {
        return uploadedFileMapper.updateBool(appKey, fileKey, "deleted");
    }

    @Override
    public List<UploadedFile> search(String appKey, Map<String, Object> parameters) {
        parameters.put("offset", 0);
        parameters.put("limit", 10);
        return uploadedFileMapper.search(appKey, parameters);
    }

    @Override
    public List<UploadedFile> search(String appKey, Map<String, Object> parameters, int offset, int limit) {
        parameters.put("offset", offset);
        parameters.put("limit", limit);
        return uploadedFileMapper.search(appKey, parameters);
    }

    @Override
    public int delete(String appKey, Long id) {
        return 0;  //To change body of implemented methods use File | Settings | File Templates.
    }

    @Autowired
    public void setUploadedFileMapper(UploadedFileMapper uploadedFileMapper) {
        this.uploadedFileMapper = uploadedFileMapper;
    }

    @Autowired
    public void setNodeMapper(NodeMapper nodeMapper) {
        this.nodeMapper = nodeMapper;
    }

}
