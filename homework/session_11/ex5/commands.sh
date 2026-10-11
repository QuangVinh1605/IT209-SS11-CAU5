#!/usr/bin/env bash
# ==============================================================================
# DevOps IT209 - Session 11 - Bài 5 (EX5)
# Nối Job tự động Build & Push Docker Image sau khi Test Gradle xanh
# Học viên: Nguyễn Quang Vinh (Vinh Nguyen)
# Repository: QuangVinh1605/IT209-SS11-CAU5
# ==============================================================================

set -eo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

REPO="QuangVinh1605/IT209-SS11-CAU5"

echo -e "${BLUE}=====================================================================${NC}"
echo -e "${GREEN}      DevOps IT209 - Session 11 - Bài 5 (EX5)                         ${NC}"
echo -e "${GREEN}  Nối Job tự động Build & Push Docker Image sau khi Test Gradle xanh  ${NC}"
echo -e "${BLUE}=====================================================================${NC}\n"

echo -e "${YELLOW}[BƯỚC 1] Kiểm tra cấu hình và chạy thử nghiệm JUnit Test tại local...${NC}"
chmod +x ./gradlew
./gradlew test bootJar
echo -e "${GREEN}✓ Local test & packaging thành công!${NC}\n"

echo -e "${YELLOW}[BƯỚC 2] Đẩy mã nguồn lên GitHub...${NC}"
git add .
git commit -m "feat: setup CI pipeline with chained jobs (needs: test) for Spring Boot app" || true
git push -u origin main
echo -e "${GREEN}✓ Đã đẩy mã nguồn lên nhánh main của $REPO thành công!${NC}\n"

echo -e "${YELLOW}[BƯỚC 3] Theo dõi trạng thái trên GitHub Actions...${NC}"
sleep 4
RUN_ID=$(gh run list -R "$REPO" --limit 1 --json databaseId -q '.[0].databaseId')

if [ -n "$RUN_ID" ]; then
    echo -e "${CYAN}Đang theo dõi Workflow Run ID: $RUN_ID...${NC}"
    gh run watch "$RUN_ID" -R "$REPO" || true
    echo -e "\n${GREEN}Chi tiết các Jobs trong Workflow:${NC}"
    gh run view "$RUN_ID" -R "$REPO"
else
    echo -e "${YELLOW}Vui lòng kiểm tra tại https://github.com/$REPO/actions${NC}"
fi

echo -e "\n${BLUE}=====================================================================${NC}"
echo -e "${GREEN}                HOÀN TẤT BƯỚC TRIỂN KHAI BÀI 5                        ${NC}"
echo -e "${BLUE}=====================================================================${NC}"
